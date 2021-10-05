import { Injectable } from "@angular/core";
import { Chat } from "../domain/chat";
import { IMessage, Message } from "../domain/message";
import { Contact } from "../domain/contact";
import { AngularFirestore, } from "@angular/fire/firestore";
import { ReplaySubject } from "rxjs";

@Injectable({
    providedIn: "root"
})
export class CommunicationService {

    readonly configuration = {
        iceServers: [
            {
                urls: [
                    "stun:stun1.l.google.com:19302",
                    "stun:stun2.l.google.com:19302"
                ]
            }
        ],
        iceCandidatePoolSize: 10
    }

    callId: string | undefined
    dataChannel: RTCDataChannel | undefined
    loadingState = false

    constructor(private db: AngularFirestore) {
        this.createOffer()
    }

    async createOffer() {
        const call = this.db.collection("calls").doc()

        const peerConnection = new RTCPeerConnection(this.configuration)

        this.dataChannel = peerConnection.createDataChannel("dataChannel")
        this.dataChannel.onmessage = event => {
            this.handleEvent(JSON.parse(event.data))
        }

        peerConnection.onicecandidate = async event => {
            const candidate = event.candidate
            if (candidate) {
                await call.collection("callerCandidates").add(candidate.toJSON())
            }
        }

        const offer = await peerConnection.createOffer()
        await peerConnection.setLocalDescription(offer)

        await call.set({ offer })
        this.callId = call.ref.id

        call.snapshotChanges().subscribe(changes => {
            const data = changes.payload.data() as any

            const answer = data.answer
            if (answer) {
                peerConnection.setRemoteDescription({
                    type: answer.type,
                    sdp: answer.sdp,
                })
            }
        })

        call.collection("calleeCandidates").snapshotChanges().subscribe(changes => {
            changes.forEach(doc => {
                if (doc.type == "added") {
                    peerConnection.addIceCandidate(doc.payload.doc.data())
                }
            })
        })
    }

    userDisplayName$ = new ReplaySubject<string>()
    userProfileImage$ = new ReplaySubject<string>()
    chats$ = new ReplaySubject<IncomingChatEvent>()
    contacts$ = new ReplaySubject<IncomingContactEvent>()
    messages$ = new ReplaySubject<IncomingMessageEvent>()

    private handleEvent(event: any): boolean {
        if (event.origin == "phone") {
            switch (event.type) {
                case "connected":
                    this.loadingState = true
                    return true
                case "userDisplayName":
                    this.handleUserDisplayName(event)
                    return true
                case "userProfileImage":
                    this.handleUserProfileImage(event)
                    return true
                case "putContact":
                    this.handlePutContact(event)
                    return true
                case "deleteContact":
                    this.handleDeleteContact(event)
                    return true
                case "putChat":
                    this.handlePutChat(event)
                    return true
                case "deleteChat":
                    this.handleDeleteChat(event)
                    return true
                case "putMessage":
                    this.handlePutMessage(event)
                    return true
                case "deleteMessage":
                    this.handleDeleteMessage(event)
                    return true
                default:
                    return false
            }
        } else {
            return false
        }
    }

    sendMessage(message: Message) {
        const event: SendMessageEvent = {
            id: message.id,
            chatId: message.chatId,
            recipientPhoneNumber: message.otherPartyPhoneNumber,
            contents: message.contents,
            timestamp: message.timestamp.getTime()
        }

        this.dataChannel?.send(JSON.stringify({
            origin: "web",
            type: "message",
            message: event,
        }))
    }

    createChat(contactPhoneNumber: string) {
        this.dataChannel?.send(JSON.stringify({
            origin: "web",
            type: "newChat",
            contactPhoneNumber: contactPhoneNumber,
        }))
    }

    sendSeen(messageIds: string[]) {
        if (messageIds.length > 0) {
            this.dataChannel?.send(JSON.stringify({
                origin: "web",
                type: "seen",
                messageIds: messageIds,
            }))
        }
    }

    private handleUserDisplayName(event: any) {
        const displayName = event.displayName

        if (displayName) {
            this.userDisplayName$.next(displayName)
        }
    }

    private handleUserProfileImage(event: any) {
        const profileImage = event.profileImage

        if (profileImage) {
            this.userProfileImage$.next(profileImage)
        }
    }

    private handlePutContact(event: any) {
        const contact = event.contact as Contact || null

        if (contact != null) {
            this.contacts$.next({
                type: IncomingEventType.PUT,
                contact: contact,
                contactPhoneNumber: contact.phoneNumber
            })
        }
    }

    private handleDeleteContact(event: any) {
        const contactPhoneNumber = event.contactPhoneNumber as string || null

        if (contactPhoneNumber != null) {
            this.contacts$.next({
                type: IncomingEventType.DELETE,
                contact: null,
                contactPhoneNumber: contactPhoneNumber
            })
        }
    }

    private handlePutChat(event: any) {
        const chat = event.chat as Chat || null

        if (chat != null) {
            this.chats$.next({
                type: IncomingEventType.PUT,
                chat: chat,
                chatId: chat.id
            })
        }
    }

    private handleDeleteChat(event: any) {
        const chatId = event.chatId as string || null

        if (chatId != null) {
            this.chats$.next({
                type: IncomingEventType.DELETE,
                chat: null,
                chatId: chatId,
            })
        }
    }

    private handlePutMessage(event: any) {
        const iMessage = event.message as IMessage || null

        if (iMessage != null) {
            const message = Message.fromIMessage(iMessage)

            this.messages$.next({
                type: IncomingEventType.PUT,
                message: message,
                messageId: message.id
            })
        }
    }

    private handleDeleteMessage(event: any) {
        const messageId = event.messageId as string || null

        if (messageId != null) {
            this.messages$.next({
                type: IncomingEventType.DELETE,
                message: null,
                messageId: messageId
            })
        }
    }
}

interface SendMessageEvent {
    id: string,
    chatId: string,
    recipientPhoneNumber: string,
    contents: string,
    timestamp: number
}

interface IncomingChatEvent {
    type: IncomingEventType,
    chat: Chat | null,
    chatId: string
}

interface IncomingContactEvent {
    type: IncomingEventType,
    contact: Contact | null,
    contactPhoneNumber: string
}

interface IncomingMessageEvent {
    type: IncomingEventType,
    message: Message | null,
    messageId: string
}

export enum IncomingEventType {
    PUT,
    DELETE
}

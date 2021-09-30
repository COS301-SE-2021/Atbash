import { Injectable } from "@angular/core";
import { Chat } from "../domain/chat";
import { Message } from "../domain/message";
import { Contact } from "../domain/contact";
import { collection, deleteDoc, doc, Firestore, onSnapshot, query, setDoc } from "@angular/fire/firestore";
import * as uuid from "uuid";
import { SHA256 } from "crypto-js";
import { ReplaySubject } from "rxjs";

@Injectable({
    providedIn: "root"
})
export class CommunicationService {

    readonly relayId = uuid.v4()
    readonly relaySymmetricKey = SHA256(uuid.v4())
    loadingState = false

    constructor(private firestore: Firestore) {
        const relayDoc = doc(collection(firestore, "relays"))
        this.relayId = relayDoc.id
        console.log(`Relay ID is ${this.relayId}`)

        const communicationCollection = collection(relayDoc, "communication")
        setDoc(doc(communicationCollection), { type: "connected", origin: "web" })

        const q = query(communicationCollection)
        onSnapshot(q, snapshot => {
            snapshot.forEach(document => {
                const handled = this.handleEvent(document.data())
                if (handled) {
                    deleteDoc(document.ref)
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
                case "setup":
                    this.handleSetup(event)
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

        setDoc(doc(this.communicationCollection), {
            origin: "web",
            type: "message",
            message: JSON.stringify(event),
        })
    }

    createChat(contactPhoneNumber: string) {
        setDoc(doc(this.communicationCollection), {
            origin: "web",
            type: "newChat",
            contactPhoneNumber: contactPhoneNumber,
        })
    }

    private get communicationCollection() {
        return collection(this.firestore, `relays/${this.relayId}/communication`)
    }

    private handleSetup(event: any) {
        const userDisplayName = event.userDisplayName as string || null
        const userProfilePhoto = event.userProfilePhoto as string || null
        const chats = JSON.parse(event.chats) as any[] || null
        const contacts = JSON.parse(event.contacts) as any[] || null
        const messages = JSON.parse(event.messages) as any[] || null

        if (userDisplayName != null) {
            this.userDisplayName$.next(userDisplayName)
        }

        chats?.forEach(c => {
            const chat = c as Chat || null
            if (chat != null) {
                this.chats$.next({
                    type: IncomingEventType.PUT,
                    chat: chat,
                    chatId: chat.id
                })
            }
        })

        contacts?.forEach(c => {
            const contact = c as Contact || null
            if (contact != null) {
                this.contacts$.next({
                    type: IncomingEventType.PUT,
                    contact: contact,
                    contactPhoneNumber: contact.phoneNumber
                })
            }
        })

        messages?.reverse()?.forEach(m => {
            const message = m as Message || null
            if (message != null) {
                this.messages$.next({
                    type: IncomingEventType.PUT,
                    message: message,
                    messageId: message.id
                })
            }
        })
    }

    private handlePutContact(event: any) {
        const contact = JSON.parse(event.contact) as Contact || null

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
        const chat = JSON.parse(event.chat) as Chat || null

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
        const message = JSON.parse(event.message) as Message || null

        if (message != null) {
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

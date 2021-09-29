import { Injectable } from "@angular/core";
import { Chat } from "../domain/chat";
import { Message } from "../domain/message";
import { Contact } from "../domain/contact";
import { collection, doc, Firestore, onSnapshot, query, setDoc } from "@angular/fire/firestore";
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

    constructor(firestore: Firestore) {
        const relayDoc = doc(collection(firestore, "relays"))
        this.relayId = relayDoc.id

        const communicationCollection = collection(relayDoc, "communication")
        setDoc(doc(communicationCollection), { type: "connected", origin: "web" })

        const q = query(communicationCollection)
        onSnapshot(q, snapshot => {
            snapshot.forEach(document => {
                this.handleEvent(document.data())
            })
        })
    }

    userDisplayName$ = new ReplaySubject<string>()
    userProfileImage$ = new ReplaySubject<string>()
    chats$ = new ReplaySubject<ChatEvent>()
    contacts$ = new ReplaySubject<ContactEvent>()
    messages$ = new ReplaySubject<MessageEvent>()

    private handleEvent(event: any) {
        if (event.origin == "phone") {
            switch (event.type) {
                case "connected":
                    this.loadingState = true
                    break
                case "setup":
                    this.handleSetup(event)
                    break
                case "putContact":
                    this.handlePutContact(event)
                    break
                case "deleteContact":
                    this.handleDeleteContact(event)
                    break
            }
        }
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
                    type: EventType.PUT,
                    chat: chat,
                    chatId: chat.id
                })
            }
        })

        contacts?.forEach(c => {
            const contact = c as Contact || null
            if (contact != null) {
                this.contacts$.next({
                    type: EventType.PUT,
                    contact: contact,
                    contactPhoneNumber: contact.phoneNumber
                })
            }
        })

        messages?.forEach(m => {
            const message = m as Message || null
            if (message != null) {
                this.messages$.next({
                    type: EventType.PUT,
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
                type: EventType.PUT,
                contact: contact,
                contactPhoneNumber: contact.phoneNumber
            })
        }
    }

    private handleDeleteContact(event: any) {
        const contactPhoneNumber = event.contactPhoneNumber as string || null

        if (contactPhoneNumber != null) {
            this.contacts$.next({
                type: EventType.DELETE,
                contact: null,
                contactPhoneNumber: contactPhoneNumber
            })
        }
    }
}

interface ChatEvent {
    type: EventType,
    chat: Chat | null,
    chatId: string
}

interface ContactEvent {
    type: EventType,
    contact: Contact | null,
    contactPhoneNumber: string
}

interface MessageEvent {
    type: EventType,
    message: Message | null,
    messageId: string
}

export enum EventType {
    PUT,
    DELETE
}

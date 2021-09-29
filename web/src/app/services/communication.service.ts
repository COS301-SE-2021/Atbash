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

    private handleEvent(event: any) {
        if (event.origin == "phone") {
            switch (event.type) {
                case "connected":
                    this.loadingState = true
                    break
                case "setup":
                    this.handleSetup(event)
                    break
            }
        }
    }

    private handleSetup(event: any) {
        console.log(event)

        const userDisplayName = event.userDisplayName as string || null
        const userProfilePhoto = event.userProfilePhoto as string || null
        const chats = JSON.parse(event.chats) as any[] || null
        const contacts = JSON.parse(event.contacts) as any[] || null
        const messages = JSON.parse(event.messages) as any[] || null

        if (userDisplayName != null) {
            this.userDisplayName$.next(userDisplayName)
        }

        chats?.forEach(chat => {
            chat = chat as Chat | null
            if (chat != null) {
                this.chats$.next(chat)
            }
        })

        contacts?.forEach(contact => {
            contact = contact as Contact | null
            if (contact != null) {
                this.contacts$.next(contact)
            }
        })

        messages?.forEach(message => {
            message = message as Message | null
            if (message != null) {
                this.messages$.next(message)
            }
        })
    }

    userDisplayName$ = new ReplaySubject<string>()
    userProfileImage$ = new ReplaySubject<string>()
    chats$ = new ReplaySubject<Chat>()
    contacts$ = new ReplaySubject<Contact>()
    messages$ = new ReplaySubject<Message>()

}

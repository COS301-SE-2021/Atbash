import { Injectable } from "@angular/core";
import { Chat, ChatType } from "../domain/chat";
import { Message, ReadReceipt } from "../domain/message";
import { Contact } from "../domain/contact";

@Injectable({
    providedIn: "root"
})
export class CommunicationService {

    constructor() {
    }

    async fetchUserDisplayName(): Promise<string> {
        return "Dylan Pfab"
    }

    async fetchUserProfileImage(): Promise<string> {
        return "https://static01.nyt.com/images/2021/09/14/science/07CAT-STRIPES/07CAT-STRIPES-mediumSquareAt3X-v2.jpg"
    }

    async fetchChatList(): Promise<Chat[]> {
        const array: Chat[] = []
        for (let i = 0; i < 20; i++) {
            array.push(CommunicationService.randomChat())
        }
        return array
    }

    async fetchContactList(): Promise<Contact[]> {
        const array: Contact[] = []
        for (let i = 0; i < 20; i++) {
            array.push(CommunicationService.randomContact())
        }
        return array
    }

    async fetchMessagesForChat(chatId: string): Promise<Message[]> {
        const array: Message[] = []
        for (let i = 0; i < 20; i++) {
            array.push(CommunicationService.randomMessage())
        }
        return array
    }

    private static randomMessage(): Message {
        const incoming = Math.random() > 0.5
        const contents = [
            "Hello",
            "Hey there",
            "How are you?",
            "Why are you ignoring me?",
            "How is it going?",
            "Whats up",
            "Hey I know you don't like long messages and all, but I am going to send you one anyway"
        ][Math.floor(Math.random() * 7)];
        const forwarded = Math.random() > 0.5
        const readReceipt = [ReadReceipt.undelivered, ReadReceipt.delivered, ReadReceipt.seen][Math.floor(Math.random() * 3)]
        const liked = Math.random() > 0.5

        return new Message(
            "",
            "",
            incoming,
            "",
            contents,
            new Date(),
            false,
            forwarded,
            readReceipt,
            null,
            false,
            liked,
            false
        )
    }

    private static randomContact(): Contact {
        const phoneNumber = this.randomString("0123456789", 10)
        const displayName = this.randomString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", 12)

        return new Contact(
            phoneNumber,
            displayName,
            "",
            "",
            null
        )
    }

    private static randomChat(): Chat {
        const contact = this.randomContact()

        return new Chat(
            "",
            contact.phoneNumber,
            contact,
            ChatType.general,
            this.randomMessage()
        )
    }

    private static randomString(characterPool: string, length: number): string {
        let result = ""
        for (let i = 0; i < length; i++) {
            result += characterPool.charAt(Math.floor(Math.random() * characterPool.length))
        }
        return result
    }
}

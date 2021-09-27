import { Injectable } from "@angular/core";
import { Chat, ChatType } from "../domain/chat";
import { Message, ReadReceipt } from "../domain/message";

@Injectable({
    providedIn: "root"
})
export class CommunicationService {

    constructor() {
    }

    async fetchChatList(): Promise<Chat[]> {
        return [
            new Chat("1", "123", null, ChatType.general, new Message(
                "",
                "",
                true,
                "123",
                "Hey there!",
                new Date(),
                false,
                false,
                ReadReceipt.undelivered,
                null,
                false,
                false,
                false,
            )),
            new Chat("2", "456", null, ChatType.general, new Message(
                "",
                "",
                true,
                "456",
                "Is this the right number?",
                new Date(),
                false,
                false,
                ReadReceipt.undelivered,
                null,
                false,
                false,
                false,
            )),
            new Chat("3", "789", null, ChatType.general, new Message(
                "",
                "",
                true,
                "789",
                "Pay me back my money",
                new Date(),
                false,
                false,
                ReadReceipt.undelivered,
                null,
                false,
                false,
                false,
            )),
            new Chat("4", "12345", null, ChatType.general, new Message(
                "",
                "",
                true,
                "12345",
                "Hey there, this is a really long message designed to test the text-overflow property",
                new Date(),
                false,
                false,
                ReadReceipt.undelivered,
                null,
                false,
                false,
                false,
            )),
            new Chat("5", "6789", null, ChatType.general, new Message(
                "",
                "",
                true,
                "6789",
                "Hey there, this is a really long message designed to test the text-overflow property",
                new Date(),
                false,
                false,
                ReadReceipt.undelivered,
                null,
                false,
                false,
                false,
            ))
        ]
    }

    async fetchMessagesForChat(chatId: string): Promise<Message[]> {
        return [
            CommunicationService.randomMessage(),
            CommunicationService.randomMessage(),
            CommunicationService.randomMessage(),
            CommunicationService.randomMessage(),
            CommunicationService.randomMessage(),
            CommunicationService.randomMessage(),
        ]
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
}

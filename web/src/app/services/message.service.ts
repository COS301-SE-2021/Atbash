import { Injectable } from "@angular/core";
import { Message, ReadReceipt } from "../domain/message";
import { Chat } from "../domain/chat";

@Injectable({
    providedIn: "root"
})
export class MessageService {

    selectedChat: Chat | null = null
    chatMessages: Message[] = []

    constructor() {
    }

    enterChat(chat: Chat | null) {
        this.selectedChat = chat
        this.chatMessages = []
    }

    sendMessage(contents: string) {
        const chatId = this.selectedChat?.id
        const recipientPhoneNumber = this.selectedChat?.contactPhoneNumber

        if (chatId != null && recipientPhoneNumber != null) {
            const message = new Message(
                "123",
                chatId,
                false,
                recipientPhoneNumber,
                contents,
                new Date(),
                false,
                false,
                ReadReceipt.undelivered,
                null,
                false,
                false,
                false
            )

            this.chatMessages.push(message)
        }
    }
}

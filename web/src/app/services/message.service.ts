import { Injectable } from "@angular/core";
import { Message, ReadReceipt } from "../domain/message";
import { Chat } from "../domain/chat";
import { CommunicationService } from "./communication.service";

@Injectable()
export class MessageService {

    selectedChat: Chat | null = null
    chatMessages: Message[] = []

    constructor(private com: CommunicationService) {
    }

    async enterChat(chat: Chat | null) {
        this.selectedChat = chat
        this.chatMessages = []
        if (chat != null) {
            this.chatMessages = await this.com.fetchMessagesForChat(chat.id)
        }
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

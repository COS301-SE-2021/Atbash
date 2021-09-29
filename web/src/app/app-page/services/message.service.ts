import { Injectable } from "@angular/core";
import { Message, ReadReceipt } from "../../domain/message";
import { Chat } from "../../domain/chat";
import { CommunicationService } from "../../services/communication.service";

@Injectable()
export class MessageService {

    selectedChat: Chat | null = null
    messageList: Message[] = []
    chatMessages: Message[] = []

    constructor(private com: CommunicationService) {
        com.messages$.subscribe(next => this.messageList.push(next))
    }

    async enterChat(chat: Chat | null) {
        this.selectedChat = chat
        this.chatMessages = []
        this.chatMessages = this.messageList.filter(message => message.chatId == chat?.id)
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

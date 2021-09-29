import { Injectable } from "@angular/core";
import { Message, ReadReceipt } from "../../domain/message";
import { Chat } from "../../domain/chat";
import { CommunicationService, EventType } from "../../services/communication.service";

@Injectable()
export class MessageService {

    selectedChat: Chat | null = null
    messageList: Message[] = []
    chatMessages: Message[] = []

    constructor(private com: CommunicationService) {
        com.messages$.subscribe(event => {
            if (event.type == EventType.PUT) {
                const message = event.message

                if (message != null) {
                    const messageListIndex = this.messageList.findIndex(m => m.id == message.id)
                    if (messageListIndex == -1) {
                        this.messageList.push(message)
                    } else {
                        this.messageList[messageListIndex] = message
                    }

                    if (message.chatId == this.selectedChat?.id) {
                        const chatMessagesIndex = this.chatMessages.findIndex(m => m.id == message.id)
                        if (chatMessagesIndex == -1) {
                            this.chatMessages.push(message)
                        } else {
                            this.chatMessages[chatMessagesIndex] = message
                        }
                    }
                }
            } else if (event.type == EventType.DELETE) {
                this.messageList = this.messageList.filter(m => m.id != event.messageId)
                this.chatMessages = this.chatMessages.filter(m => m.id != event.messageId)
            }
        })
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

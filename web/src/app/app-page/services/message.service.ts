import { Injectable } from "@angular/core";
import { Message, ReadReceipt } from "../../domain/message";
import { Chat } from "../../domain/chat";
import { CommunicationService, IncomingEventType } from "../../services/communication.service";
import * as uuid from "uuid";
import { ChatService } from "./chat.service";

@Injectable()
export class MessageService {

    selectedChat: Chat | null = null
    messageList: Message[] = []
    chatMessages: Message[] = []

    constructor(private com: CommunicationService, private chatService: ChatService) {
        com.messages$.subscribe(event => {
            if (event.type == IncomingEventType.PUT) {
                const message = event.message

                if (message != null) {
                    const messageListIndex = this.messageList.findIndex(m => m.id == message.id)
                    if (messageListIndex == -1) {
                        this.messageList.push(message)
                        this.messageList.sort((a, b) => a.timestamp.getTime() - b.timestamp.getTime())
                        chatService.updateChatMostRecentMessage(this.messageList[this.messageList.length - 1])
                    } else {
                        this.messageList[messageListIndex] = message
                    }

                    if (message.chatId == this.selectedChat?.id) {
                        const chatMessagesIndex = this.chatMessages.findIndex(m => m.id == message.id)
                        if (chatMessagesIndex == -1) {
                            this.chatMessages.push(message)
                            this.chatMessages.sort((a, b) => a.timestamp.getTime() - b.timestamp.getTime())
                        } else {
                            this.chatMessages[chatMessagesIndex] = message
                        }
                        if (message.isIncoming && message.readReceipt != ReadReceipt.seen) {
                            message.readReceipt = ReadReceipt.seen
                            this.com.sendSeen([message.id])
                        }
                    }
                }
            } else if (event.type == IncomingEventType.DELETE) {
                this.messageList = this.messageList.filter(m => m.id != event.messageId)
                this.chatMessages = this.chatMessages.filter(m => m.id != event.messageId)
            }
        })
    }

    enterChat(chat: Chat | null) {
        this.selectedChat = chat
        this.chatMessages = []
        this.chatMessages = this.messageList.filter(message => {
            if (message.chatId == chat?.id) {
                if (message.isIncoming && message.readReceipt != ReadReceipt.seen) {
                    message.readReceipt = ReadReceipt.seen
                    this.com.sendSeen([message.id])
                }

                return true
            } else {
                return false
            }
        })
    }

    sendMessage(contents: string) {
        const chatId = this.selectedChat?.id
        const recipientPhoneNumber = this.selectedChat?.contactPhoneNumber

        if (chatId != null && recipientPhoneNumber != null) {
            const message = new Message(
                uuid.v4(),
                chatId,
                false,
                recipientPhoneNumber,
                contents,
                new Date(),
                false,
                false,
                ReadReceipt.undelivered,
                undefined,
                false,
                false,
                false
            )

            this.chatMessages.push(message)
            this.com.sendMessage(message)
        }
    }
}

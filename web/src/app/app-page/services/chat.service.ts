import { Injectable } from "@angular/core";
import { CommunicationService, IncomingEventType } from "../../services/communication.service";
import { Chat, ChatType } from "../../domain/chat";
import * as uuid from "uuid";
import { ContactService } from "./contact.service";

@Injectable()
export class ChatService {

    chatList: Chat[] = []

    constructor(private com: CommunicationService, private contactService: ContactService) {
        com.chats$.subscribe(event => {
            if (event.type == IncomingEventType.PUT) {
                const chat = event.chat

                if (chat != null) {
                    const index = this.chatList.findIndex(c => c.id == chat.id)
                    if (index == -1) {
                        this.chatList.push(chat)
                    } else {
                        this.chatList[index] = chat
                    }
                }
            } else if (event.type == IncomingEventType.DELETE) {
                this.chatList = this.chatList.filter(c => c.id != event.chatId)
            }
        })
    }

    createChatIfNone(contactPhoneNumber: string): Chat {
        const existingChat = this.chatList.find(chat => chat.contactPhoneNumber == contactPhoneNumber) || null

        if (existingChat == null) {
            const contact = this.contactService.contactList.find(contact => contact.phoneNumber == contactPhoneNumber) || null
            const chat = new Chat(uuid.v4(), contactPhoneNumber, contact, ChatType.general, null)
            this.chatList.push(chat)
            this.com.createChat(contactPhoneNumber)
            return chat
        } else {
            return existingChat
        }
    }
}

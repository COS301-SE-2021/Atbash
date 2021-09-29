import { Injectable } from "@angular/core";
import { CommunicationService, IncomingEventType } from "../../services/communication.service";
import { Chat } from "../../domain/chat";

@Injectable()
export class ChatService {

    chatList: Chat[] = []

    constructor(private com: CommunicationService) {
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
}

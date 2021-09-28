import { Injectable } from "@angular/core";
import { CommunicationService } from "../../services/communication.service";
import { Chat } from "../../domain/chat";

@Injectable()
export class ChatService {

    chatList: Chat[] = []

    constructor(private com: CommunicationService) {
        com.fetchChatList().then(chats => this.chatList = chats)
    }
}
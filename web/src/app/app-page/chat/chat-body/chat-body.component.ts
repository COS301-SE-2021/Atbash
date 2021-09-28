import { Component, OnInit } from "@angular/core";
import { MessageService } from "../../services/message.service";

@Component({
    selector: "app-chat-body",
    templateUrl: "./chat-body.component.html",
    styleUrls: ["./chat-body.component.scss"]
})
export class ChatBodyComponent implements OnInit {

    constructor(private messageService: MessageService) {
    }

    ngOnInit(): void {
    }

    get chat() {
        return this.messageService.selectedChat
    }

    get messages() {
        return this.messageService.chatMessages
    }

    get isInChat() {
        return this.chat != null
    }

}

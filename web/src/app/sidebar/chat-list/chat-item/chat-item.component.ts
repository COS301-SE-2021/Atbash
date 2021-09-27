import { Component, Input, OnInit } from "@angular/core";
import { Chat } from "../../../domain/chat";
import { MessageService } from "../../../services/message.service";

@Component({
    selector: "app-chat-item",
    templateUrl: "./chat-item.component.html",
    styleUrls: ["./chat-item.component.scss"]
})
export class ChatItemComponent implements OnInit {

    // LOCAL STATE
    @Input() chat: Chat | null = null

    constructor(private messageService: MessageService) {
    }

    ngOnInit(): void {
    }

    selectChat() {
        this.messageService.enterChat(this.chat)
    }

}

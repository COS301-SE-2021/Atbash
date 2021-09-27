import { Component, OnInit } from "@angular/core";
import { MessageService } from "../../services/message.service";

@Component({
    selector: "app-chat-input-bar",
    templateUrl: "./chat-input-bar.component.html",
    styleUrls: ["./chat-input-bar.component.scss"]
})
export class ChatInputBarComponent implements OnInit {

    inputBarContents: string = ""

    constructor(private messageService: MessageService) {
    }

    ngOnInit(): void {
    }

    get chat() {
        return this.messageService.selectedChat
    }

    sendMessage() {
        const contents = this.inputBarContents.trim()
        if (contents) {
            this.messageService.sendMessage(contents)
            this.inputBarContents = ""
        }
    }

    get isInChat() {
        return this.chat != null
    }

}

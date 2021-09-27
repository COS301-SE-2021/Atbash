import { Component, Input, OnInit } from "@angular/core";
import { MessageService } from "../../services/message.service";

@Component({
    selector: "app-chat-title-bar",
    templateUrl: "./chat-title-bar.component.html",
    styleUrls: ["./chat-title-bar.component.scss"]
})
export class ChatTitleBarComponent implements OnInit {

    // LOCAL STATE
    @Input() profileImage: string | null = null
    @Input() displayName: string | null = null

    constructor(private messageService: MessageService) {
    }

    ngOnInit(): void {
    }

    get isInChat() {
        return this.messageService.selectedChat != null
    }

}

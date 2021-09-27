import { Component, OnInit } from "@angular/core";
import { MessageService } from "../../services/message.service";

@Component({
    selector: "app-chat-title-bar",
    templateUrl: "./chat-title-bar.component.html",
    styleUrls: ["./chat-title-bar.component.scss"]
})
export class ChatTitleBarComponent implements OnInit {

    constructor(private messageService: MessageService) {
    }

    ngOnInit(): void {
    }

    get profileImage() {
        return this.messageService.selectedChat?.contact?.profileImage ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
    }

    get displayName() {
        return this.messageService.selectedChat?.contact?.displayName ?? this.messageService?.selectedChat?.contactPhoneNumber
    }

    get isInChat() {
        return this.messageService.selectedChat != null
    }

}

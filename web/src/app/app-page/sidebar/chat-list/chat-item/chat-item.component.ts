import { Component, Input, OnInit } from "@angular/core";
import { Chat } from "../../../../domain/chat";
import { MessageService } from "../../../services/message.service";
import { calculateImageMimeType } from "../../../../utils/utils";

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

    get profileImage() {
        let profileImage = this.chat?.contact?.profileImage
        if (profileImage == null || profileImage.trim() == "") {
            profileImage = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
        } else {
            profileImage = `data:${calculateImageMimeType(profileImage)};base64,${profileImage}`
        }
        return profileImage
    }

    get displayName() {
        return this.chat?.contact?.displayName ?? this.chat?.contactPhoneNumber ?? ""
    }

    get mostRecentMessage() {
        return this.chat?.mostRecentMessage
    }

    selectChat() {
        this.messageService.enterChat(this.chat)
    }

}

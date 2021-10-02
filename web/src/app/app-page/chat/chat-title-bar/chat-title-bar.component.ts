import { Component, OnInit } from "@angular/core";
import { MessageService } from "../../services/message.service";
import { calculateImageMimeType } from "../../../utils/utils";

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

    get chat() {
        return this.messageService.selectedChat
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

    get isInChat() {
        return this.chat != null
    }

}

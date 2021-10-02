import { Component, Input, OnInit } from "@angular/core";
import { Message } from "../../../../domain/message";
import { calculateImageMimeType } from "../../../../utils/utils";

@Component({
    selector: "app-chat-body-message",
    templateUrl: "./chat-body-message.component.html",
    styleUrls: ["./chat-body-message.component.scss"]
})
export class ChatBodyMessageComponent implements OnInit {

    @Input() message: Message | null = null

    constructor() {
    }

    ngOnInit(): void {
    }

    get isMediaMessage() {
        return this.message?.isMedia == true
    }

    get mediaContents() {
        if (this.message != null) {
            return `data:${calculateImageMimeType(this.message.contents)};base64,${this.message.contents}`
        } else {
            return "https://i.stack.imgur.com/y9DpT.jpg"
        }
    }

}

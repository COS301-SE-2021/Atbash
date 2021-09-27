import { Component, Input, OnInit } from "@angular/core";
import { Message } from "../../../domain/message";

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

}

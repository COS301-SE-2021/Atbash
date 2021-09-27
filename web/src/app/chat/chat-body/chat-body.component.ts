import { Component, OnInit } from "@angular/core";
import { Message, ReadReceipt } from "../../domain/message";

@Component({
    selector: "app-chat-body",
    templateUrl: "./chat-body.component.html",
    styleUrls: ["./chat-body.component.scss"]
})
export class ChatBodyComponent implements OnInit {

    messages: Message[] = []

    constructor() {
    }

    ngOnInit(): void {
        for (let i = 0; i < 50; i++) {
            const isIncoming = Math.random() > 0.5
            const m = new Message(
                "",
                "",
                isIncoming,
                "6789",
                "This is a message that is very long so as to extend the maximum width available to force it to wrap. This means that it will wrap now",
                new Date(),
                false,
                false,
                ReadReceipt.undelivered,
                null,
                false,
                false,
                false,
            )
            this.messages.push(m)
        }
    }

}

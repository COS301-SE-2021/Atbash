import { Component, OnInit } from "@angular/core";
import { Message } from "../../domain/message";
import { MessageService } from "../../services/message.service";

@Component({
    selector: "app-chat-body",
    templateUrl: "./chat-body.component.html",
    styleUrls: ["./chat-body.component.scss"]
})
export class ChatBodyComponent implements OnInit {

    messages: Message[] = []

    constructor(private messageService: MessageService) {
    }

    ngOnInit(): void {
        this.messageService.messages.subscribe(nextMessage => {
            this.messages.push(nextMessage)
        })
    }

}

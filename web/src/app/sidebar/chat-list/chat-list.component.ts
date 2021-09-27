import { Component, OnInit } from "@angular/core";
import { Chat, ChatType } from "../../domain/chat";
import { Message, ReadReceipt } from "../../domain/message";

@Component({
    selector: "app-chat-list",
    templateUrl: "./chat-list.component.html",
    styleUrls: ["./chat-list.component.scss"]
})
export class ChatListComponent implements OnInit {

    // LOCAL STATE
    chatList: Chat[] = []

    constructor() {
    }

    ngOnInit(): void {
        this.chatList = [
            new Chat("1", "123", null, ChatType.general, null),
            new Chat("2", "456", null, ChatType.general, null),
            new Chat("3", "789", null, ChatType.general, null),
            new Chat("4", "12345", null, ChatType.general, null),
            new Chat("5", "6789", null, ChatType.general, new Message(
                "",
                "",
                true,
                "6789",
                "Hey there, this is a really long message designed to test the text-overflow property",
                new Date(),
                false,
                false,
                ReadReceipt.undelivered,
                null,
                false,
                false,
                false,
            )),
        ]
    }

}

import { Injectable } from "@angular/core";
import { Message, ReadReceipt } from "../domain/message";
import { Subject } from "rxjs";

@Injectable({
    providedIn: "root"
})
export class MessageService {

    messages = new Subject<Message>()

    constructor() {
    }

    sendMessage(contents: string, recipientPhoneNumber: string) {
        const message = new Message(
            "123",
            "123",
            false,
            recipientPhoneNumber,
            contents,
            new Date(),
            false,
            false,
            ReadReceipt.undelivered,
            null,
            false,
            false,
            false
        )

        this.messages.next(message)
    }
}

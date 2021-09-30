import { Component, OnInit } from "@angular/core";
import { ChatService } from "./services/chat.service";
import { ContactService } from "./services/contact.service";
import { MessageService } from "./services/message.service";
import { UserService } from "./services/user.service";

@Component({
    selector: "app-app-page",
    templateUrl: "./app-page.component.html",
    styleUrls: ["./app-page.component.scss"],
    providers: [ChatService, ContactService, MessageService, UserService]
})
export class AppPageComponent implements OnInit {

    constructor() {
    }

    ngOnInit(): void {
    }

}

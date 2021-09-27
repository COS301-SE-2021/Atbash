import { Component, Input, OnInit } from "@angular/core";

@Component({
    selector: "app-chat-title-bar",
    templateUrl: "./chat-title-bar.component.html",
    styleUrls: ["./chat-title-bar.component.scss"]
})
export class ChatTitleBarComponent implements OnInit {

    // LOCAL STATE
    @Input() profileImage: string | null = null
    @Input() displayName: string | null = null

    constructor() {
    }

    ngOnInit(): void {
    }

}

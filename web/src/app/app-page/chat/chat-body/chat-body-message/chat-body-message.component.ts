import { Component, Input, OnInit } from "@angular/core";
import { Message } from "../../../../domain/message";
import { calculateImageMimeType } from "../../../../utils/utils";
import { NgbModal } from "@ng-bootstrap/ng-bootstrap";
import { ImageViewModal } from "../../../image-view/image-view.modal";

@Component({
    selector: "app-chat-body-message",
    templateUrl: "./chat-body-message.component.html",
    styleUrls: ["./chat-body-message.component.scss"]
})
export class ChatBodyMessageComponent implements OnInit {

    @Input() message: Message | null = null

    constructor(private modalService: NgbModal) {
    }

    ngOnInit(): void {
    }

    get messageContents() {
        if (this.message != null) {
            return this.message.deleted ? "This message was deleted" : this.message.contents
        } else {
            return ""
        }
    }

    get messageTimestamp() {
        if (this.message != null) {
            return this.message.timestamp
        } else {
            return new Date()
        }
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

    enlargeImage() {
        const contents = this.message?.contents ?? null

        if (contents != null) {
            const modalRef = this.modalService.open(ImageViewModal, { size: "lg" })
            const instance = modalRef.componentInstance as ImageViewModal
            instance.base64Image = contents
        }
    }

}

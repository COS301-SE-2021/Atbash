import { Component, Input, OnInit } from "@angular/core";
import { Message, ReadReceipt } from "../../../../domain/message";
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

    get messageTimestamp() {
        return this.message?.timestamp ?? new Date()
    }

    get readStatusSVG() {
        if (this.message != null) {
            switch (this.message?.readReceipt) {
                case ReadReceipt.undelivered:
                    return "assets/close_black_24dp.svg";
                case ReadReceipt.delivered:
                    return "assets/done_black_24dp.svg";
                case ReadReceipt.seen:
                    return "assets/done_all_black_24dp.svg";
            }
        }
        return "assets/close_black_24dp.svg";
    }
}

import { Component, OnInit } from "@angular/core";
import { calculateImageMimeType } from "../../utils/utils";

@Component({
    templateUrl: "./image-view.modal.html",
    styleUrls: ["./image-view.modal.scss"]
})
export class ImageViewModal implements OnInit {

    base64Image: string | null = null

    constructor() {
    }

    ngOnInit(): void {
    }

    get image() {
        if (this.base64Image == null) {
            return "https://i.stack.imgur.com/y9DpT.jpg"
        } else {
            return `data:${calculateImageMimeType(this.base64Image)};base64,${this.base64Image}`
        }
    }

}

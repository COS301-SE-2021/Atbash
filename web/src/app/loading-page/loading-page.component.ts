import { Component, OnInit } from "@angular/core";
import { NgxQrcodeElementTypes, NgxQrcodeErrorCorrectionLevels } from "@techiediaries/ngx-qrcode";
import { CommunicationService } from "../services/communication.service";

@Component({
    selector: "app-loading-page",
    templateUrl: "./loading-page.component.html",
    styleUrls: ["./loading-page.component.scss"]
})
export class LoadingPageComponent implements OnInit {

    elementType = NgxQrcodeElementTypes.IMG
    correctionLevel = NgxQrcodeErrorCorrectionLevels.HIGH

    constructor(private com: CommunicationService) {
    }

    get qrCodeValue() {
        return `@b,${this.com.callId}`
    }

    ngOnInit(): void {
    }

}

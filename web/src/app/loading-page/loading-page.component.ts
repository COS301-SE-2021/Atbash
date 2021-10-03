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
    qrCodeValue: string

    constructor(private com: CommunicationService) {
        this.qrCodeValue = `@b,${com.callId}`
    }

    ngOnInit(): void {
    }

}

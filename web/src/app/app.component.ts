import { Component } from "@angular/core";
import { CommunicationService } from "./services/communication.service";

@Component({
    selector: "app-root",
    templateUrl: "./app.component.html",
    styleUrls: ["./app.component.scss"]
})
export class AppComponent {

    constructor(private com: CommunicationService) {
    }

    get loaded() {
        return this.com.loadingState
    }
}

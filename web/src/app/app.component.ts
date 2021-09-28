import { Component } from "@angular/core";
import { CommunicationService } from "./services/communication.service";

@Component({
    selector: "app-root",
    templateUrl: "./app.component.html",
    styleUrls: ["./app.component.scss"]
})
export class AppComponent {

    loaded = false

    constructor(private com: CommunicationService) {
        com.loadingState.subscribe(loadingState => this.loaded = loadingState)
    }
}

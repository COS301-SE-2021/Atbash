import { Component } from "@angular/core";
import { CommunicationService, LoadingState } from "./services/communication.service";

@Component({
    selector: "app-root",
    templateUrl: "./app.component.html",
    styleUrls: ["./app.component.scss"]
})
export class AppComponent {

    readonly loading = LoadingState.loading
    readonly waiting_connection = LoadingState.waiting_connection
    readonly connected = LoadingState.connected

    loadingState = LoadingState.loading

    constructor(private com: CommunicationService) {
        com.loadingState.subscribe(loadingState => this.loadingState = loadingState)
    }
}

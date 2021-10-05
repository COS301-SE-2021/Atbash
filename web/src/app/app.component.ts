import { ChangeDetectorRef, Component } from "@angular/core";
import { CommunicationService } from "./services/communication.service";

@Component({
    selector: "app-root",
    templateUrl: "./app.component.html",
    styleUrls: ["./app.component.scss"]
})
export class AppComponent {

    constructor(private com: CommunicationService, private cd: ChangeDetectorRef) {
        // TODO really inefficient, remove once change detection figured out
        setInterval(() => {
            cd.detectChanges()
        }, 500)
    }

    get loaded() {
        return this.com.loadingState
    }
}

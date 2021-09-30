import { Component, OnInit } from "@angular/core";
import { SidebarService } from "./services/sidebar.service";

@Component({
    selector: "app-sidebar",
    templateUrl: "./sidebar.component.html",
    styleUrls: ["./sidebar.component.scss"],
    providers: [SidebarService]
})
export class SidebarComponent implements OnInit {

    constructor(private sidebarService: SidebarService) {
    }

    ngOnInit(): void {
    }

    get shouldShowContactList() {
        return this.sidebarService.showContactList
    }

}

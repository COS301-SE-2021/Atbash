import { Component, OnInit } from "@angular/core";
import { UserService } from "../../services/user.service";
import { SidebarService } from "../sidebar-service/sidebar.service";

@Component({
    selector: "app-title-bar",
    templateUrl: "./title-bar.component.html",
    styleUrls: ["./title-bar.component.scss"]
})
export class TitleBarComponent implements OnInit {

    constructor(private userService: UserService, private sidebarService: SidebarService) {
    }

    ngOnInit(): void {
    }

    get profileImage() {
        let profileImage = this.userService.profileImage
        if (profileImage == null || profileImage.trim() == "") {
            profileImage = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
        }
        return profileImage
    }

    get displayName() {
        return this.userService.displayName
    }

    get shouldShowBackArrow() {
        return this.sidebarService.showContactList
    }

    startNewChat() {
        this.sidebarService.showContactList = true
    }

    backPressed() {
        this.sidebarService.showContactList = false
    }

}

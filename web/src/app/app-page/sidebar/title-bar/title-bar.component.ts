import { Component, OnInit } from "@angular/core";
import { UserService } from "../../services/user.service";
import { SidebarService } from "../services/sidebar.service";
import { calculateImageMimeType } from "../../../utils/utils";

@Component({
    selector: "app-title-bar",
    templateUrl: "./title-bar.component.html",
    styleUrls: ["./title-bar.component.scss"]
})
export class TitleBarComponent implements OnInit {

    // STATE
    displayName: string | undefined
    private _profileImage: string | undefined

    constructor(private userService: UserService, private sidebarService: SidebarService) {
        userService.displayName$.subscribe(next => this.displayName = next)
        userService.profileImage$.subscribe(next => this._profileImage = next)
    }

    ngOnInit(): void {
    }

    get profileImage() {
        let profileImage = this._profileImage
        if (profileImage == null || profileImage.trim() == "") {
            profileImage = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
        } else {
            profileImage = `data:${calculateImageMimeType(profileImage)};base64,${profileImage}`
        }
        return profileImage
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

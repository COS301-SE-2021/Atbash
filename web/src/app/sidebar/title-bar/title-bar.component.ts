import { Component, OnInit } from "@angular/core";

@Component({
    selector: "app-title-bar",
    templateUrl: "./title-bar.component.html",
    styleUrls: ["./title-bar.component.scss"]
})
export class TitleBarComponent implements OnInit {

    // LOCAL STATE
    profileImage: string | null = "https://static01.nyt.com/images/2021/09/14/science/07CAT-STRIPES/07CAT-STRIPES-mediumSquareAt3X-v2.jpg"
    displayName: string = "Dylan Pfab"

    constructor() {
    }

    ngOnInit(): void {
    }

}

import { NgModule } from "@angular/core";
import { BrowserModule } from "@angular/platform-browser";

import { AppComponent } from "./app.component";
import { ChatComponent } from "./chat/chat.component";
import { SidebarComponent } from "./sidebar/sidebar.component";
import { TitleBarComponent } from "./sidebar/title-bar/title-bar.component";

@NgModule({
    declarations: [
        AppComponent,
        ChatComponent,
        SidebarComponent,
        TitleBarComponent
    ],
    imports: [
        BrowserModule
    ],
    providers: [],
    bootstrap: [AppComponent]
})
export class AppModule {
}

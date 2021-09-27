import { NgModule } from "@angular/core";
import { BrowserModule } from "@angular/platform-browser";

import { AppComponent } from "./app.component";
import { ChatComponent } from "./chat/chat.component";
import { SidebarComponent } from "./sidebar/sidebar.component";
import { TitleBarComponent } from "./sidebar/title-bar/title-bar.component";
import { ChatListComponent } from "./sidebar/chat-list/chat-list.component";
import { ChatItemComponent } from "./sidebar/chat-list/chat-item/chat-item.component";
import { ChatTitleBarComponent } from './chat/chat-title-bar/chat-title-bar.component';

@NgModule({
    declarations: [
        AppComponent,
        ChatComponent,
        SidebarComponent,
        TitleBarComponent,
        ChatListComponent,
        ChatItemComponent,
        ChatTitleBarComponent
    ],
    imports: [
        BrowserModule
    ],
    providers: [],
    bootstrap: [AppComponent]
})
export class AppModule {
}

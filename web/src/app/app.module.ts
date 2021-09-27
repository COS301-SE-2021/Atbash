import { NgModule } from "@angular/core";
import { BrowserModule } from "@angular/platform-browser";

import { AppComponent } from "./app.component";
import { ChatComponent } from "./chat/chat.component";
import { SidebarComponent } from "./sidebar/sidebar.component";
import { TitleBarComponent } from "./sidebar/title-bar/title-bar.component";
import { ChatListComponent } from "./sidebar/chat-list/chat-list.component";
import { ChatItemComponent } from "./sidebar/chat-list/chat-item/chat-item.component";
import { ChatTitleBarComponent } from "./chat/chat-title-bar/chat-title-bar.component";
import { ChatBodyComponent } from "./chat/chat-body/chat-body.component";
import { ChatInputBarComponent } from "./chat/chat-input-bar/chat-input-bar.component";
import { ChatBodyMessageComponent } from "./chat/chat-body/chat-body-message/chat-body-message.component";
import { FormsModule } from "@angular/forms";
import { ContactListComponent } from './sidebar/contact-list/contact-list.component';
import { ContactItemComponent } from './sidebar/contact-list/contact-item/contact-item.component';

@NgModule({
    declarations: [
        AppComponent,
        ChatComponent,
        SidebarComponent,
        TitleBarComponent,
        ChatListComponent,
        ChatItemComponent,
        ChatTitleBarComponent,
        ChatBodyComponent,
        ChatInputBarComponent,
        ChatBodyMessageComponent,
        ContactListComponent,
        ContactItemComponent
    ],
    imports: [
        BrowserModule,
        FormsModule
    ],
    providers: [],
    bootstrap: [AppComponent]
})
export class AppModule {
}

import { NgModule } from "@angular/core";
import { BrowserModule } from "@angular/platform-browser";

import { AppComponent } from "./app.component";
import { ChatComponent } from "./app-page/chat/chat.component";
import { SidebarComponent } from "./app-page/sidebar/sidebar.component";
import { TitleBarComponent } from "./app-page/sidebar/title-bar/title-bar.component";
import { ChatListComponent } from "./app-page/sidebar/chat-list/chat-list.component";
import { ChatItemComponent } from "./app-page/sidebar/chat-list/chat-item/chat-item.component";
import { ChatTitleBarComponent } from "./app-page/chat/chat-title-bar/chat-title-bar.component";
import { ChatBodyComponent } from "./app-page/chat/chat-body/chat-body.component";
import { ChatInputBarComponent } from "./app-page/chat/chat-input-bar/chat-input-bar.component";
import { ChatBodyMessageComponent } from "./app-page/chat/chat-body/chat-body-message/chat-body-message.component";
import { FormsModule } from "@angular/forms";
import { ContactListComponent } from './app-page/sidebar/contact-list/contact-list.component';
import { ContactItemComponent } from './app-page/sidebar/contact-list/contact-item/contact-item.component';
import { LoadingPageComponent } from './loading-page/loading-page.component';
import { AppPageComponent } from './app-page/app-page.component';

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
        ContactItemComponent,
        LoadingPageComponent,
        AppPageComponent
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

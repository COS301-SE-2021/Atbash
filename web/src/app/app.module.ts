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
import { initializeApp, provideFirebaseApp } from "@angular/fire/app";
import { getFirestore, provideFirestore } from "@angular/fire/firestore";
import { NgxQRCodeModule } from "@techiediaries/ngx-qrcode";
import { ImageViewModal } from './app-page/image-view/image-view.modal';

const firebaseConfig = {
    apiKey: "AIzaSyCh6lYwbK46C5UarTn0NE9dCTnaAVdD2Qo",
    authDomain: "atbash-f0b75.firebaseapp.com",
    projectId: "atbash-f0b75",
    storageBucket: "atbash-f0b75.appspot.com",
    messagingSenderId: "953759627144",
    appId: "1:953759627144:web:eaf9e8bf7f1cbbe3172c3d",
    measurementId: "G-BTLQ773TKN"
}

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
        AppPageComponent,
        ImageViewModal
    ],
    imports: [
        BrowserModule,
        FormsModule,
        provideFirebaseApp(() => initializeApp(firebaseConfig)),
        provideFirestore(() => getFirestore()),
        NgxQRCodeModule
    ],
    providers: [],
    bootstrap: [AppComponent]
})
export class AppModule {
}

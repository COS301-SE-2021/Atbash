export function calculateImageMimeType(base64Image: string): string {
    if (base64Image.startsWith("R0lGODdh")) return "image/gif"
    if (base64Image.startsWith("R0lGODlh")) return "image/gif"
    if (base64Image.startsWith("iVBORw0KGgo")) return "image/png"
    if (base64Image.startsWith("/9j/")) return "image/jpeg"

    return "image/jpeg"
}

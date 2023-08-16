import "@/styles/globals.css";
import { NextUIProvider } from "@nextui-org/react";
import { ThemeProvider as NextThemesProvider } from "next-themes";
import { fontSans, fontMono } from "@/config/fonts";
import type { AppProps } from "next/app";
import { SigninProvider } from "./signin-context";
import { Amplify } from 'aws-amplify'
import { awsExport } from '../config/aws-export';
Amplify.configure(awsExport);
export default function App({ Component, pageProps }: AppProps) {
	return (
		<SigninProvider>
		<NextUIProvider>
			<NextThemesProvider>
				<Component {...pageProps} />
			</NextThemesProvider>
		</NextUIProvider>
		</SigninProvider>
	);
}

export const fonts = {
	sans: fontSans.style.fontFamily,
	mono: fontMono.style.fontFamily,
};

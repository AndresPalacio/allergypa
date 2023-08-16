import { createContext, useContext, useState } from "react";
import { Auth } from 'aws-amplify'


interface SigninContextProps {
  signedIn: boolean;
  signIn: (email: string, password: string) => void;
  signOut: () => void;
}

const SigninContext = createContext<SigninContextProps>({
  signedIn: false,
  signIn: () => {},
  signOut: () => {},
});

export function useSignin() {
  return useContext(SigninContext);
}

export function SigninProvider({ children }: { children: React.ReactNode }) {
  const [signedIn, setSignedIn] = useState(false);

  const signIn = async (email: string, password: string) => {
    try {
      await Auth.signIn(email, password);
      // await Auth.completeNewPassword(user, password) genera la excepcion

      setSignedIn(true);
    } catch (error) {
      console.error("Sign in error:", error);
    }
  };

  const signOut = async () => {
    await Auth.signOut();
    setSignedIn(false);
    console.log("signedIn set to false");
  };



  return (
    <SigninContext.Provider value={{ signedIn, signIn, signOut}}>
      {children}
    </SigninContext.Provider>
  );
}
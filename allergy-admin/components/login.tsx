import React, { useState } from "react";
import { Modal, ModalContent, ModalHeader, ModalBody, ModalFooter, Button, useDisclosure, Checkbox, Input, Link } from "@nextui-org/react";
import { MailIcon } from "@/components/MailIcon";
import { LockIcon } from "@/components/LockIcon";
import { useSignin } from "@/pages/signin-context";
import { Auth } from 'aws-amplify'



export default function Login() {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const { signedIn, signIn, signOut } = useSignin();



  async function login() {
    try {
      await signIn(email, password);
      onClose();
    } catch (error) {
      console.log('error signing in', error);
    }
  }


  async function handleSignIn(){
    setIsLoading(true);
    await login();
    setIsLoading(false);
  }

  return (
    <>
      <Button onPress={onOpen} color="primary">Login</Button>
      <Modal
        isOpen={isOpen}
        onClose={onClose}
        placement="top-center"
      >
        <ModalContent>
          <ModalHeader className="flex flex-col gap-1">Log in</ModalHeader>
          <ModalBody>
            <Input
              autoFocus
              endContent={
                <MailIcon className="text-2xl text-default-400 pointer-events-none flex-shrink-0" />
              }
              label="Email"
              placeholder="Enter your email"
              variant="bordered"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
            <Input
              endContent={
                <LockIcon className="text-2xl text-default-400 pointer-events-none flex-shrink-0" />
              }
              label="Password"
              placeholder="Enter your password"
              type="password"
              variant="bordered"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
            <div className="flex py-2 px-1 justify-between">
              <Checkbox
                classNames={{
                  label: "text-small",
                }}
              >
                Remember me
              </Checkbox>
              <Link color="primary" href="#" size="sm">
                Forgot password?
              </Link>
            </div>
          </ModalBody>
          <ModalFooter>
            <Button color="danger" variant="flat" onClick={onClose}>
              Close
            </Button>
            <Button color="primary" onPress={handleSignIn} disabled={isLoading}>
              {isLoading ? "Loading..." : "Sign in"}
            </Button>
          </ModalFooter>
        </ModalContent>
      </Modal>
    </>
  );
}
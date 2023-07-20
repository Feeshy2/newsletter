package;

import js.html.InputElement;
import react.ReactHooks;

private typedef AppState = {
    showThankState:Bool
}

class App extends ReactComponent {
    public static var email:String;

    public var showThankState(default, set):Bool;

    public function new() {
        super();

        email = "";
        this.state = {showThankState: false};
    }

    public function set_showThankState(value:Bool):Bool {
        this.setState(function(previousState:AppState):AppState {
            return {showThankState: value}
        });

        return showThankState = value;
    }

    override function render() {
        if(!this.state.showThankState) {
            return jsx('
                <div>
                    <div className="newsletter">
                        <Signup parent={this} />
                    </div>

                    <div className="credits">
                        Challenge by&nbsp;<a href="https://www.frontendmentor.io?ref=challenge" target="_blank" className="underline">Frontend Mentor</a>
                        . Coded by&nbsp;<a href="https://github.com/Just-Feeshy" target="_blank" className="underline">Diego Fonseca</a>.
                    </div>
                </div>
            ');
        }else {
            return jsx('
                <div>
                    <div className="newsletter">
                        <Thank parent={this} />
                    </div>

                    <div className="credits">
                        <div className="promo" style={{display: "flex", justifyContent: "center", alignItems: "center"}}>
                            Mainly programmed with Haxe
                            <img className="haxe-image" src="haxe-logo.svg" alt="logo" style={{display: "block", width: "40px"}} />
                        </div>
                    </div>
                </div>
            ');
        }
    }
}


/* Signup */

private function isValidEmail(email:String):Bool {
    var regex = new EReg("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", "");
    return regex.match(email);
}

private function checkElement(item:String):ReactElement {
    return jsx('
        <div className="checkelement">
            <img src="/icon-list.svg" width="50" height="50" />
            <p>${item}</p>
        </div>
    ');
}

private function subscribe(emailInput:{current:InputElement}, parent:App, hook:HookState<Bool>):Void {
    if(emailInput.current == null) {
        return;
    }

    var isValid = isValidEmail(emailInput.current.value);
    hook.value = !isValid;

    if(!hook.value) {
        parent.showThankState = true;
        App.email = emailInput.current.value;
    }
}

function Signup(props:{parent:App}):ReactElement {
    var activeError = ReactHooks.useState(false);
    var emailInput = ReactHooks.useRef(null);

    var items:Array<String> = [
        "Product discovery and building what matters",
        "Measuring to ensure updates are a success",
        "And much more!"
    ];

    var itemElements = items.map(checkElement);

    function setRef(ref:Dynamic):Void {
        emailInput.current = ref;
    }

    return jsx('
        <div className="signup">
            <div className="info">
                <h1>Stay updated!</h1>
                <p>
                    Join 60,000+ product managers recieving receiving monthly updates on:
                </p>
                <div className="checklist">
                    ${itemElements}
                </div>
                <div className="userinputs">
                    <div className="label-box">
                        <div className="email">Email address</div>
                        <div className="error">
                            ${activeError.value ? "Valid email required" : ""}
                        </div>
                    </div>
                    <input
                        ref=${setRef}
                        type="email"
                        placeholder="email@company.com"
                        style={{
                            borderColor: activeError.value ? "hsl(4, 100%, 67%)" : "",
                            color: activeError.value ? "hsl(4, 100%, 67%)" : ""
                        }}
                    />
                    <button onClick=${e->subscribe(emailInput, props.parent, activeError)}>Subscribe to monthly newsletter</button>
                </div>
            </div>
            
            <div className="right">
                <img src="/illustration-sign-up-desktop.svg" height="600px" />
            </div>
        </div>
    ');
}


/* Thank */

private function dismiss(parent:App):Void {
    parent.showThankState = false;
}

function Thank(props:{parent:App}):ReactElement {
    return jsx('
        <div className="thanks">
            <div>
                <div><img src="/icon-success.svg" /></div>
                <h1>Thanks for subscribing!</h1>
                <p>
                    A confirmation email has been sent to <span>${App.email}</span>
                    . Please open it and click the button inside to confirm your subscription.
                </p>
            </div>
            <button onClick=${e->dismiss(props.parent)}>Dismiss message</button>
        </div>
    ');
}
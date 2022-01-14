
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

var num_letters_in_alphabet = 26
var num_letters_to_gen = 3

function getName(i) {
  // ASCII lowercase letter range: [0x61, 0x7A]
  const offset = 0x61

  let str = ""

  for (var idx = num_letters_to_gen - 1; idx >= 0; --idx ) {
    // Unit value of this character, or, how much an increment represents.
    const inc = num_letters_in_alphabet ** idx;
//     console.log(`Working on char ${idx} of ${num_letters_to_gen - 1} (Increments of ${inc}).`)
    // Value of this character.
    let val = 0;
    // Run for as long as we can subtract from the integer.
    for (; i >= inc; val++) {
//       console.log(`  i: ${i} -> ${i - inc}; val: ${val} -> ${val + 1}.`);
      // Subtract from the integer by the multiplier.
      i -= inc;
    }
    // Convert the ASCII code to
    str += String.fromCharCode(offset + val);
  }

  return str + `seria`
}

names = ""

async function tryNames() {
  // Obtain the input element. The "name" attribute is a unique identifier.
  const input = document.querySelectorAll('[name="typedScreenName"]')[0];
  // Obtain the input's value tracker. We'll need this for some React hackery:
  // https://github.com/facebook/react/issues/11488#issuecomment-884790146
	const tracker = input._valueTracker;
  // Initialize a generic input event that will bubble up the DOM.
  const ev = new Event('input', { bubbles: true});

  // For every possible n-letter combination.
  for (i = 0; i < (num_letters_in_alphabet ** num_letters_to_gen) - 1; ++i) {
    // Get the name corresponding for this index.
   	let name = getName(i);

		// Set the desired value.
    input.value = name;

		// Clear the value to force the change to be recognized.
    tracker.setValue("");
    // Trigger the input event.
    input.dispatchEvent(ev);

    // Wait two seconds to be totally sure that Twitter understands.
    await sleep(2000);
		if (document.querySelectorAll('[aria-live="assertive"]').length === 0)
 			names += name + " "
  }
  console.log(names);
}

tryNames()

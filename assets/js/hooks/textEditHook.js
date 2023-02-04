import Quill from "quill";
export let TextEditor = {
  mounted() {
    console.log("Miro Mounting text editor", this.el, this);

    // console.log('miroPost:', miroPost);

    let quill = new Quill(this.el, {
      modules: {
        toolbar: [
          [{ header: [1, 2, false] }],
          ["bold", "italic", "underline", "strike", "blockquote"],
          [
            { list: "ordered" },
            { list: "bullet" },
            { indent: "-1" },
            { indent: "+1" },
          ],
          ["link"], // ['link', 'image'],
          ["clean"],
        ],
      },
      theme: "snow",
    });

    // https://quilljs.com/docs/api/#setcontents
    // quill.setContents(delta: Delta, source: String = 'api'): Delta
    // dbData = { "ops": [{ "insert": "xx\n" }] }
    // quill.setContents(dbData)
    // quill.setContents({ "ops": [{ "insert": "xox\n" }] })

    quill.on("text-change", (delta, oldDelta, source) => {
      if (source == "api") {
        console.log("An API call triggered this change.");
      } else if (source == "user") {
        // console.log(this.el.phxHookId);
        // console.log(quill.getContents());
        //   console.log(this);
        //This sends the event of
        // def handle_event("text-editor", %{"text_content" => content}, socket) do
        // this.pushEventTo(this.el.phxHookId, "text-editor", {"text_content": quill.getContents()})

        // this below works: (those above probably don't)
        // this.pushEvent("text-editor", { "text_content": quill.getContents() })
        this.pushEventTo("#journal_entry", "text-editor", {
          text_content: quill.getContents(),
        });
      }
    });

    window.addEventListener("phx:miroFromServer", (e) => {
      // console.log("miro: e from server received:", e)
      // let quill0 = JSON.parse(e.detail.savedQuills[0])
      // console.log("miro: quill 0 :", quill0);
      // // quill.setContents(quill0)

      //   console.log("miro: e from server received:", e);
      //   //   let quill0 = JSON.parse(e.detail.savedQuills[0]);
      //   //   console.log("miro: quill 0 :", quill0);
      //   //   quill.setContents(quill0);
      //   //   asText = quill.getText(quill0);
      //   //   console.log("miro: quill 0 text:", asText);
      //   //   this.pushEventTo("#journal_entry", "existingJE_as_text", {
      //   //     text_content: asText,
      //   //   });

      console.log("miro: e from server received:", e);
      //   let je = JSON.parse(e.detail.savedJE);
      //   //   text = quill.getText(je.content);
      //   textContent = je.content;
      //   id = je.id;

      //   el_id = "#content_of_existing_journal_entry_id_" + id;
      //   console.log("miro: el_id :", el_id);
      //   let quill1 = new Quill(el_id);
      //   //   el = document.querySelector(`#${el_id}`);
      //   el = document.querySelector(el_id);
      //   console.log("miro: el :", el);

      //   //   console.log("miro: je :", id, textContent);
      //   // document.getElementById("journal_entry").value = je;
      //   quill1.setContents(textContent);
      //   //   console.log("miro: quill 0 text:", asText);
      //   //   this.pushEventTo("#journal_entry", "existingJE_as_text", {
      //   //     text_content: asText,
      //   //   });
    });
  },
  updated() {
    console.log("U");
  },
};

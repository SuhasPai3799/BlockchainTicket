App = {
    loading: false,
    contracts: {},
  
    load: async () => {
      await App.loadWeb3()
      await App.loadAccount()
      await App.loadContract()
      await App.render()
    },
  
    // https://medium.com/metamask/https-medium-com-metamask-breaking-change-injecting-web3-7722797916a8
    loadWeb3: async () => {
      if (typeof web3 !== 'undefined') {
        App.web3Provider = web3.currentProvider
        web3 = new Web3(web3.currentProvider)
      } else {
        window.alert("Please connect to Metamask.")
      }
      // Modern dapp browsers...
      if (window.ethereum) {
        window.web3 = new Web3(ethereum)
        try {
          // Request account access if needed
          await ethereum.enable()
          // Acccounts now exposed
          web3.eth.sendTransaction({/* ... */})
        } catch (error) {
          // User denied account access...
        }
      }
      // Legacy dapp browsers...
      else if (window.web3) {
        App.web3Provider = web3.currentProvider
        window.web3 = new Web3(web3.currentProvider)
        // Acccounts always exposed
        web3.eth.sendTransaction({/* ... */})
      }
      // Non-dapp browsers...
      else {
        console.log('Non-Ethereum browser detected. You should consider trying MetaMask!')
      }
    },
  
    loadAccount: async () => {
      // Set the current blockchain account
      App.account = web3.eth.accounts[0]
      console.log(App.account)
      console.log(web3.eth)
    },
  
    loadContract: async () => {
      // Create a JavaScript version of the smart contract
      const todoList = await $.getJSON('TodoList.json')
      const ticketSystem = await $.getJSON('TicketSystem.json')
      App.contracts.TodoList = TruffleContract(todoList)
      App.contracts.TicketSystem = TruffleContract(ticketSystem)
      App.contracts.TodoList.setProvider(App.web3Provider)
      App.contracts.TicketSystem.setProvider(App.web3Provider)
      // Hydrate the smart contract with values from the blockchain
      App.todoList = await App.contracts.TodoList.deployed()
      App.tickets  = await App.contracts.TicketSystem.deployed()

      
      console.log(App.contracts.TicketSystem.address)
      console.log(App.contracts.TodoList.address)
    },
  
    render: async () => {
      // Prevent double render
      if (App.loading) {
        return
      }
  
      // Update app loading state
      App.setLoading(true)
  
      // Render Account
      $('#account').html(App.account)
  
      // Render Tasks
      await App.renderTasks()
  
      // Update loading state
      App.setLoading(false)
    },
  
    renderTasks: async () => {
      // Load the total task count from the blockchain
      const taskCount = await App.todoList.taskCount()
      const ticketCount = await App.tickets.tot_tickets()
      const gg = await App.tickets.balanceOf()
      const gg1 =  await App.todoList.balanceOf()
      console.log(ticketCount)
      console.log(gg)
      console.log(gg1)
      for(var i=0;i<5;i++)
      {
    	  const latest_tick = await App.tickets.tickets(i)
		  console.log(latest_tick)
	  }
      const $taskTemplate = $('.taskTemplate')
      //console.log(taskCount)
      // Render out each task with a new task template
      for (var i = 1; i <= taskCount; i++) {
        // Fetch the task data from the blockchain
        const task = await App.todoList.tasks(i)
        const taskId = task[0].toNumber()
        const taskContent = task[1]
        const taskCompleted = task[2]
        //console.log(task[3])
  
        // Create the html for the task
        const $newTaskTemplate = $taskTemplate.clone()
        $newTaskTemplate.find('.content').html(taskContent)
        $newTaskTemplate.find('input')
                        .prop('name', taskId)
                        .prop('checked', taskCompleted)
                        // .on('click', App.toggleCompleted)
  
        // Put the task in the correct list
        if (taskCompleted) {
          $('#completedTaskList').append($newTaskTemplate)
        } else {
          $('#taskList').append($newTaskTemplate)
        }
  
        // Show the task
        $newTaskTemplate.show()
      }
	},
	buyTicket : async () => {
		App.setLoading(true)
		await App.tickets.deposit({
			from: App.account,
			value: 1000000000000000000,
			gas: "4712388"
		  })
		window.location.reload()
	},
	sellTicket : async () => {
		App.setLoading(true)
		await App.tickets.redeem_to_pool(App.account)
		window.location.reload()
	},
    createTask: async () => {
        App.setLoading(true)
        console.log(App.account)
        const content = $('#newTask').val()
        await App.todoList.createTask(content,App.account)
        await App.tickets.deposit({
          from: App.account,
          value: 1000000000000000000,
          gas: "4712388"
		})
		//await App.tickets.redeem_to_pool(App.account)
        //await App.tickets.buyTicket(App.account)
        // const bal = await App.tickets.balanceOf()
        // console.log(bal)  
        window.location.reload()
      },
    setLoading: (boolean) => {
      App.loading = boolean
      const loader = $('#loader')
      const content = $('#content')
      if (boolean) {
        loader.show()
        content.hide()
      } else {
        loader.hide()
        content.show()
      }
    }
  }
  
  
  $(() => {
    $(window).load(() => {
      App.load()
    })
  })
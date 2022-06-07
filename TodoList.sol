// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Todolist {
    struct Todo {
        string task;
        bool status;
    }

    Todo[] public todos;

    function create(string calldata _task) external {
        todos.push(Todo({
            task: _task,
            status: false
        }));
    }

    function updateTodo(uint _index, string calldata _task) external {
        todos[_index].task = _task;

        // Todo storage todo = todos[_index];
        // todo.task = _task;
    }

    function get(uint _index) external view returns(string memory _task, bool) {
        Todo memory todo = todos[_index];
        return (todo.task, todo.status);
    }

    function toggleStatus(uint _index) external {
        todos[_index].status = !todos[_index].status;
    
    }
}